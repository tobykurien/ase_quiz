package za.org.ase.quiz;

import com.tobykurien.sparkler.Sparkler;
import java.util.Collections;
import org.eclipse.xtext.xbase.lib.CollectionLiterals;
import org.eclipse.xtext.xbase.lib.Functions.Function2;
import spark.Request;
import spark.Response;
import spark.servlet.SparkApplication;

@SuppressWarnings("all")
public class Main implements SparkApplication {
  public void init() {
    final String workingDir = System.getProperty("user.dir");
    Sparkler.externalStaticFileLocation((workingDir + "/public"));
    final Function2<Request, Response, Object> _function = new Function2<Request, Response, Object>() {
      public Object apply(final Request req, final Response res) {
        return Sparkler.render("views/index.html", Collections.<String, Object>unmodifiableMap(CollectionLiterals.<String, Object>newHashMap()));
      }
    };
    Sparkler.get("/", _function);
    final Function2<Request, Response, Object> _function_1 = new Function2<Request, Response, Object>() {
      public Object apply(final Request $0, final Response $1) {
        return Sparkler.render("views/test.html", Collections.<String, Object>unmodifiableMap(CollectionLiterals.<String, Object>newHashMap()));
      }
    };
    Sparkler.get("/test", _function_1);
  }
  
  public static void main(final String[] args) {
    Main _main = new Main();
    _main.init();
  }
}
