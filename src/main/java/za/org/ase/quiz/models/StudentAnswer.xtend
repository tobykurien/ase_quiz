package za.org.ase.quiz.models

import com.tobykurien.sparkler.db.DbField
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='student_id',parent=Student)
class StudentAnswer extends Model {
   @DbField String answerText      
}