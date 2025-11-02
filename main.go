package main

import (
	"fmt"
	"math/rand"

	"github.com/gin-gonic/gin"
)

func main() {

	sentences := []string{
		"You don’t need motivation, you need momentum.",
		"Small wins beat big excuses.",
	}

	route := gin.Default() // start the route definition

	route.GET("/app", func(c *gin.Context) { // what to listen fore
		randomIndex := rand.Intn(len(sentences)) // what happen when u go to this path

		randominute := rand.Intn(45) + 5 // from 5 to 50

		fmt.Println(sentences[randomIndex]) // to debug, index for witch sentence to print
		fmt.Println(randominute)

		c.JSON(200, gin.H{ // what are you sending to the client
			"message": sentences[randomIndex],
			"minutes": randominute,
		})
	})
	route.Run("127.0.0.1:8080") // local host

}
