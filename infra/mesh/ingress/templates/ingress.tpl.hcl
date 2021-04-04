Kind = "ingress-gateway"
Name = "ingress-service"

Listeners = [


 {
   Port = "8080"
   Protocol = "http"
   Services = [
      {
        Name = "vegetables"
      },
   ]
 },

 {
   Port = "8090"
   Protocol = "http"
   Services = [
      {
        Name = "superheroes"
      },
   ]
 },


]
