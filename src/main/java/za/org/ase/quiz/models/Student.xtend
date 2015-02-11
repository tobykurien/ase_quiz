package za.org.ase.quiz.models

import com.tobykurien.sparkler.db.DbField
import java.util.Date
import org.javalite.activejdbc.Model

/**
 * Student represents a user (can also be a teacher or admin)
 */
class Student extends Model {
   @DbField Date createdAt
   @DbField String username
   
   val static validations = {
      validatePresenceOf("username")
   }
}
