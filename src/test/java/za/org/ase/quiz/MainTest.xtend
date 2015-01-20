package za.org.ase.quiz

import com.tobykurien.sparkler.test.TestSupport
import org.junit.Test

class MainTest extends TestSupport {
   override getModelPackageName() {
      // Where your database Model classes are
      Main.package.name 
   }
   
   @Test
   def shouldPass() {
      the("Hello message").shouldNotBeNull
   }
}
