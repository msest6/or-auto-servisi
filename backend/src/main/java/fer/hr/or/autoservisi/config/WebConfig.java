package fer.hr.or.autoservisi.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Dopušta Angular aplikaciji na http://localhost:4200 pozive prema back-endu
 * na http://localhost:8080 (inače bi ih preglednik blokirao zbog CORS-a).
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/**")
                .allowedOrigins("http://localhost:4200")
                .allowedMethods("GET", "POST", "PUT", "DELETE")
                .exposedHeaders("Content-Disposition");
    }
}
