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
	// swagger library
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
		log.Fatal(err) // Log the error for debugging
	}
	defer conn.Close(context.Background())

	// Create the customers table if it doesn't exist
	_, err = conn.Exec(context.Background(), `CREATE TABLE IF NOT EXISTS customers (
		customer_nr SERIAL PRIMARY KEY,
		firm TEXT NOT NULL,
		phone_nr TEXT,
		mail TEXT,
		location TEXT
	);`)
	if err != nil {
		log.Fatal(err) // Log the error for debugging
	}

	// Create the products table if it doesn't exist
	_, err = conn.Exec(context.Background(), `CREATE TABLE IF NOT EXISTS products (
		product_id SERIAL PRIMARY KEY,
		customer_nr INT NOT NULL,
		meter_id INT NOT NULL,
		product_nr TEXT NOT NULL,
		oil_type TEXT NOT NULL,
		barrel_type TEXT NOT NULL,
		height REAL NOT NULL,
		FOREIGN KEY (customer_nr) REFERENCES customers(customer_nr) ON DELETE CASCADE
	);`)
	if err != nil {
		log.Fatal(err) // Log the error for debugging
	}

	// Set up HTTP routes
	http.HandleFunc("/api/customers", fetchCustomersHandler)
	http.HandleFunc("/api/products", fetchProductsHandler)
	http.HandleFunc("/swagger/", httpSwagger.WrapHandler) // Swagger UI endpoint

	// Start the server
	log.Println("Starting server on :8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err) // Log the error for debugging
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
	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, "Could not connect to database", http.StatusInternalServerError)
		log.Println("Database connection error:", err) // Log the error for debugging
		return
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT * FROM customers")
	if err != nil {
		http.Error(w, "Could not query customers", http.StatusInternalServerError)
		log.Println("Query error:", err) // Log the error for debugging
		return
	}
	defer rows.Close()

	var customers []Customer
	for rows.Next() {
		var customer Customer
		if err := rows.Scan(&customer.CustomerNr, &customer.Firm, &customer.PhoneNr, &customer.Mail, &customer.Location); err != nil {
			http.Error(w, "Could not scan customer", http.StatusInternalServerError)
			log.Println("Scan error:", err) // Log the error for debugging
			return
		}
		customers = append(customers, customer)
	}

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
	connStr := os.Getenv("DATABASE_URL")
	conn, err := pgx.Connect(context.Background(), connStr)
	if err != nil {
		http.Error(w, "Could not connect to database", http.StatusInternalServerError)
		log.Println("Database connection error:", err) // Log the error for debugging
		return
	}
	defer conn.Close(context.Background())

	rows, err := conn.Query(context.Background(), "SELECT * FROM products")
	if err != nil {
		http.Error(w, "Could not query products", http.StatusInternalServerError)
		log.Println("Query error:", err) // Log the error for debugging
		return
	}
	defer rows.Close()

	var products []Product
	for rows.Next() {
		var product Product
		if err := rows.Scan(&product.ProductID, &product.CustomerNr, &product.MeterID, &product.ProductNr, &product.OilType, &product.BarrelType, &product.Height); err != nil {
			http.Error(w, "Could not scan product", http.StatusInternalServerError)
			log.Println("Scan error:", err) // Log the error for debugging
			return
		}
		products = append(products, product)
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(products)
}
