package za.org.ase.quiz.routes

import com.tobykurien.sparkler.Sparkler

abstract class BaseRoute extends Sparkler {
   public val static API_PREFIX = "/api/v1"
   
   def void load()
}