package za.org.ase.quiz

import com.tobykurien.sparkler.db.DatabaseManager
import com.tobykurien.sparkler.utils.Log
import org.javalite.activejdbc.LogFilter
import spark.servlet.SparkApplication
import za.org.ase.quiz.models.Student
import za.org.ase.quiz.routes.AdminRoutes
import za.org.ase.quiz.routes.AnswerRoutes
import za.org.ase.quiz.routes.BaseRoute
import za.org.ase.quiz.routes.LoginRoutes
import za.org.ase.quiz.routes.QuestionRoutes
import za.org.ase.quiz.routes.QuizRoutes

import static com.tobykurien.sparkler.Sparkler.*

import static extension za.org.ase.quiz.Helper.*
import za.org.ase.quiz.routes.StudentRoutes

class Main implements SparkApplication {
   
   override init() {
      // these are optional initializers, must be set before routes
      //setPort(4567) // port to bind on startup, default is 4567
      if (isDev()) LogFilter.setLogExpression("Query\\:.*");
      DatabaseManager.init(Student.package.name) // init db with package containing db models

      // Set up path to static files
      val workingDir = System.getProperty("user.dir")
      externalStaticFileLocation(workingDir + "/public")      
      
      // Set up site-wide authentication
      before [ req, res, filter |
         if (req.pathInfo.startsWith("/css/") || 
             req.pathInfo.startsWith("/javascript/") ||
             req.pathInfo.startsWith("/bower_components/") ||
             req.pathInfo.startsWith(BaseRoute.API_PREFIX)) {
            // these are needed to display the login screen    
            return
         }
         
         if (!req.pathInfo.startsWith("/login")) {
            if (req.student == null) {
               if (!req.pathInfo.startsWith(BaseRoute.API_PREFIX)) res.redirect("/login")
               filter.haltFilter(401, "Unauthorised")
            }
         }
      ]
      
      // Homepage
      get("/") [req, res|
         render("views/index.html", #{})
      ]
            
      new LoginRoutes().load()
      new AdminRoutes().load()
      new QuizRoutes().load()
      new QuestionRoutes().load()
      new AnswerRoutes().load()
      new StudentRoutes().load()
   }
   
   def static void main(String[] args) {
      new Main().init();
   }
}
