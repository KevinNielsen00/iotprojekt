package models

// Customer represents a customer record in the database
type Customer struct {
	CustomerNr int32  `json:"customer_nr"`
	Firm       string `json:"firm"`
	PhoneNr    string `json:"phone_nr"`
	Mail       string `json:"mail"`
	Location   string `json:"location"`
}
