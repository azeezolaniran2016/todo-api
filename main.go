package main

import (
	"fmt"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(r http.ResponseWriter, _ *http.Request) {
		fmt.Printf("Handling request\n")
		r.Header().Set("Content-Type", "application/json")
		r.WriteHeader(200)
		r.Write([]byte(`
			{
				"msg": "Hello World"
			}
		`))
	})
	fmt.Printf("Error occurred when starting server: %+v", http.ListenAndServe("", nil))
}
