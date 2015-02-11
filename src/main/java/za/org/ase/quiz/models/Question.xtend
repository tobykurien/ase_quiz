package za.org.ase.quiz.models

import com.tobykurien.sparkler.utils.Log
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='quiz_id',parent=Quiz)
class Question extends Model {
    
   def Integer getPoints() {
      return try {
         getInteger("points")
      } catch (Exception e) {
         Log.e("Answer", "Error getting points", e)
         0
      } 
   }
     
}