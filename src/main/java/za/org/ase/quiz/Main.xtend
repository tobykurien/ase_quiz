package za.org.ase.quiz

import spark.servlet.SparkApplication

import static com.tobykurien.sparkler.Sparkler.*
import za.org.ase.quiz.routes.LoginRoutes

class Main implements SparkApplication {
   
   override init() {
      // these are optional initializers, must be set before routes
      //setPort(4567) // port to bind on startup, default is 4567

      // Set up path to static files
      val workingDir = System.getProperty("user.dir")
      externalStaticFileLocation(workingDir + "/public")      
      
      // Homepage
      get("/") [req, res|
         render("views/index.html", #{})
      ]
      
      new LoginRoutes().load()
   }
   
   def static void main(String[] args) {
      new Main().init();
   }
}
