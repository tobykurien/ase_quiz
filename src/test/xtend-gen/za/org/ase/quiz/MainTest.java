package za.org.ase.quiz;

import com.tobykurien.sparkler.test.TestSupport;
import org.javalite.test.jspec.Expectation;
import org.junit.Test;
import za.org.ase.quiz.Main;

@SuppressWarnings("all")
public class MainTest extends TestSupport {
  public String getModelPackageName() {
    Package _package = Main.class.getPackage();
    return _package.getName();
  }
  
  @Test
  public void shouldPass() {
    Expectation<Object> _the = this.the("Hello message");
    _the.shouldNotBeNull();
  }
}
