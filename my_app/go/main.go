package main

import (
	"context"
	"log"
	"net/http"
	"os"

	_ "my_app/docs"

	"github.com/gin-gonic/gin"
	"github.com/jackc/pgx/v5"
	"github.com/joho/godotenv"
	httpSwagger "github.com/swaggo/http-swagger" // swagger middleware
)

// Customer represents a customer record in the database
type Customer struct {
	CustomerNr int32  `json:"customer_nr"`
	Firm       string `json:"firm"`
	PhoneNr    string `json:"phone_nr"`
	Mail       string `json:"mail"`
	Location   string `json:"location"`
}

// Product represents a product record in the database
type Product struct {
	ProductID  int32   `json:"product_id"`
	CustomerNr int32   `json:"customer_nr"`
	MeterID    int32   `json:"meter_id"`
	ProductNr  string  `json:"product_nr"`
	OilType    string  `json:"oil_type"`
	BarrelType string  `json:"barrel_type"`
	Height     float32 `json:"height"`
}

// ErrorResponse represents a structured error response
type ErrorResponse struct {
	Error   string `json:"error"`
	Message string `json:"message,omitempty"`
}

// @title My API
// @version 1.0
// @description This is a sample API for managing customers and products.
// @host localhost:8080
// @BasePath /api
func main() {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file")
	}

	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v\n", err)
	}
	defer conn.Close(context.Background())

	log.Println("Successfully connected to the database")

	r := gin.Default()

	// Define routes
	r.GET("/api/customers", fetchCustomersHandler)
	r.GET("/api/products", fetchProductsHandler)
	r.GET("/swagger/*any", gin.WrapH(httpSwagger.WrapHandler)) // Swagger UI endpoint

	r.POST("/api/customers", createCustomerHandler)
	r.POST("/api/products", createProductHandler)

	// Start the server
	log.Fatal(r.Run(":8080"))
}

// fetchCustomersHandler handles GET requests to fetch all customers
// @Summary Get all customers
// @Description Get a list of all customers
// @Tags customers
// @Produce json
// @Success 200 {array} Customer
// @Failure 500 {object} ErrorResponse
// @Router /customers [get]
func fetchCustomersHandler(c *gin.Context) {
	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		log.Printf("Could not connect to database: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not connect to database"})
		return
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT * FROM customers")
	if err != nil {
		log.Printf("Could not query customers: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not query customers"})
		return
	}
	defer rows.Close()

	var customers []Customer
	for rows.Next() {
		var customer Customer
		if err := rows.Scan(&customer.CustomerNr, &customer.Firm, &customer.PhoneNr, &customer.Mail, &customer.Location); err != nil {
			log.Printf("Scan error: %v\n", err)
			c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not scan customer"})
			return
		}
		customers = append(customers, customer)
	}

	c.JSON(http.StatusOK, customers)
}

// fetchProductsHandler handles GET requests to fetch all products
// @Summary Get all products
// @Description Get a list of all products
// @Tags products
// @Produce json
// @Success 200 {array} Product
// @Failure 500 {object} ErrorResponse
// @Router /products [get]
func fetchProductsHandler(c *gin.Context) {
	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		log.Printf("Could not connect to database: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not connect to database"})
		return
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT * FROM products")
	if err != nil {
		log.Printf("Could not query products: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not query products"})
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var product Product
		if err := rows.Scan(&product.ProductID, &product.CustomerNr, &product.MeterID, &product.ProductNr, &product.OilType, &product.BarrelType, &product.Height); err != nil {
			log.Printf("Scan error: %v\n", err)
			c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not scan product"})
			return
		}
		products = append(products, product)
	}

	c.JSON(http.StatusOK, products)
}

// createCustomerHandler handles POST requests to create a new customer
// @Summary Create a new customer
// @Description Add a new customer to the database
// @Tags customers
// @Accept json
// @Produce json
// @Param customer body Customer true "Customer data"
// @Success 201 {object} map[string]string
// @Failure 400 {object} ErrorResponse
// @Failure 500 {object} ErrorResponse
// @Router /customers [post]
func createCustomerHandler(c *gin.Context) {
	var newCustomer Customer

	// Bind the incoming JSON to the newCustomer struct
	if err := c.BindJSON(&newCustomer); err != nil {
		log.Printf("Invalid JSON format: %v\n", err)
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid input"})
		return
	}

	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		log.Printf("Could not connect to database: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not connect to database"})
		return
	}
	defer conn.Close(context.Background())

	// Insert the new customer into the database
	query := `INSERT INTO customers (customer_nr, firm, phone_nr, mail, location) VALUES ($1, $2, $3, $4, $5)`
	_, err = conn.Exec(context.Background(), query, newCustomer.CustomerNr, newCustomer.Firm, newCustomer.PhoneNr, newCustomer.Mail, newCustomer.Location)
	if err != nil {
		log.Printf("Could not insert customer: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not create customer"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Customer created successfully"})
}

// createProductHandler handles POST requests to create a new product
// @Summary Create a new product
// @Description Add a new product to the database
// @Tags products
// @Accept json
// @Produce json
// @Param product body Product true "Product data"
// @Success 201 {object} map[string]string
// @Failure 400 {object} ErrorResponse
// @Failure 500 {object} ErrorResponse
// @Router /products [post]
func createProductHandler(c *gin.Context) {
	var newProduct Product

	// Bind the incoming JSON to the newProduct struct
	if err := c.BindJSON(&newProduct); err != nil {
		log.Printf("Invalid JSON format: %v\n", err)
		c.JSON(http.StatusBadRequest, ErrorResponse{Error: "Invalid input"})
		return
	}

	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		log.Printf("Could not connect to database: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not connect to database"})
		return
	}
	defer conn.Close(context.Background())

	// Insert the new product into the database
	query := `INSERT INTO products (customer_nr, meter_id, product_nr, oil_type, barrel_type, height) VALUES ($1, $2, $3, $4, $5, $6)`
	_, err = conn.Exec(context.Background(), query, newProduct.CustomerNr, newProduct.MeterID, newProduct.ProductNr, newProduct.OilType, newProduct.BarrelType, newProduct.Height)
	if err != nil {
		log.Printf("Could not insert product: %v\n", err)
		c.JSON(http.StatusInternalServerError, ErrorResponse{Error: "Could not create product"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{"message": "Product created successfully"})
}
