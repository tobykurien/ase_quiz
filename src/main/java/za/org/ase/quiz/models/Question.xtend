package za.org.ase.quiz.models

import com.tobykurien.sparkler.db.DbField
import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='quiz_id',parent=Quiz)
class Question extends Model {
   @DbField String question
   @DbField String questionPic
   @DbField String questionAudio
   @DbField String questionVideo
   @DbField long points = -1
}