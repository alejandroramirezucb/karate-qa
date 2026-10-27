import com.intuit.karate.junit5.Karate;

class TestRunner {
    @Karate.Test
    Karate testAll() {
        return Karate.run(
            "features/usuarios.feature",
            "features/posts.feature",
            "features/comentarios.feature"
        ).relativeTo(getClass());
    }
}
