package za.org.ase.quiz.routes

import com.tobykurien.sparkler.Sparkler

abstract class BaseRoute extends Sparkler {
   def void load()
}