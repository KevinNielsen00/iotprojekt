package models

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
