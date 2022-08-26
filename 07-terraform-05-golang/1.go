package main

import "fmt"

    func main() {
        fmt.Print("Enter value in foot: ")
        var input float64
        fmt.Scanf("%f", &input)
        output := input * float64(0.3048)
        fmt.Println("Value in Meters:", output)
    }
