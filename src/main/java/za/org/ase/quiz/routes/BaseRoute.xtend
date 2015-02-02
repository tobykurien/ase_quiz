package za.org.ase.quiz.routes

import com.tobykurien.sparkler.Sparkler
import spark.Request
import za.org.ase.quiz.Helper

abstract class BaseRoute extends Sparkler {
   public val static API_PREFIX = "/api/v1"
   
   def boolean isAdmin(Request req) {
      Helper.isAdmin(req)      
   }
   
   def void load()
}