package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"

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
		log.Fatal("Error connecting to the database:", err) // Log connection error
	}
	defer conn.Close(context.Background())

	log.Println("Successfully connected to the database")
	// Create tables and insert sample data here

	// Log handlers registration
	http.HandleFunc("/api/customers", fetchCustomersHandler)
	http.HandleFunc("/api/products", fetchProductsHandler)
	http.HandleFunc("/swagger/", httpSwagger.WrapHandler) // Swagger UI endpoint

	log.Println("Starting server on :8080") // Log server start
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal("Error starting server:", err) // Log server start error
	}
}

// fetchCustomersHandler handles GET requests to fetch all customers
// @Summary Get all customers
// @Description Get a list of all customers
// @Tags customers
// @Produce json
// @Success 200 {array} Customer
// @Failure 500 {object} map[string]interface{}
// @Router /api/customers [get]
func fetchCustomersHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	log.Println("Received request to fetch customers") // Log when the handler is called
	handleCustomerFetch(w)
}

// handleCustomerFetch is a helper function to fetch customers from the database
func handleCustomerFetch(w http.ResponseWriter) {
	connStr := os.Getenv("DATABASE_URL")
	log.Println("Connecting to database") // Log connection attempt
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, "Could not connect to database", http.StatusInternalServerError)
		log.Println("Database connection error:", err)
		return
	}
	defer conn.Close(context.Background())

	log.Println("Querying customers from the database") // Log before querying
	rows, err := conn.Query(context.Background(), "SELECT * FROM customers")
	if err != nil {
		http.Error(w, "Could not query customers", http.StatusInternalServerError)
		log.Println("Query error:", err)
		return
	}
	defer rows.Close()

	var customers []Customer
	for rows.Next() {
		var customer Customer
		if err := rows.Scan(&customer.CustomerNr, &customer.Firm, &customer.PhoneNr, &customer.Mail, &customer.Location); err != nil {
			http.Error(w, "Could not scan customer", http.StatusInternalServerError)
			log.Println("Scan error:", err)
			return
		}
		customers = append(customers, customer)
	}

	log.Printf("Successfully fetched %d customers", len(customers)) // Log successful fetch
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(customers)
}

// fetchProductsHandler handles GET requests to fetch all products
// @Summary Get all products
// @Description Get a list of all products
// @Tags products
// @Produce json
// @Success 200 {array} Product
// @Failure 500 {object} map[string]interface{}
// @Router /api/products [get]
func fetchProductsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Access-Control-Allow-Origin", "*")
	log.Println("Received request to fetch products") // Log when the handler is called
	handleProductFetch(w)
}

// handleProductFetch is a helper function to fetch products from the database
func handleProductFetch(w http.ResponseWriter) {
	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, "Could not connect to database", http.StatusInternalServerError)
		log.Println("Database connection error:", err)
		return
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT * FROM products")
	if err != nil {
		http.Error(w, "Could not query products", http.StatusInternalServerError)
		log.Println("Query error:", err)
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var product Product
		if err := rows.Scan(&product.ProductID, &product.CustomerNr, &product.MeterID, &product.ProductNr, &product.OilType, &product.BarrelType, &product.Height); err != nil {
			http.Error(w, "Could not scan product", http.StatusInternalServerError)
			log.Println("Scan error:", err)
			return
		}
		products = append(products, product)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}
