package gabriel.fontes.br.quarkus.Config;

import io.quarkus.arc.profile.IfBuildProfile;
import io.quarkus.runtime.ShutdownEvent;
import io.quarkus.runtime.StartupEvent;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import org.eclipse.microprofile.config.inject.ConfigProperty;
import org.jboss.logging.Logger;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.wait.strategy.Wait;

import java.time.Duration;
import java.util.List;

@ApplicationScoped
@IfBuildProfile("dev")
public class SeaweedFSDevService {

    private static final Logger LOG = Logger.getLogger(SeaweedFSDevService.class);

    private static final String IMAGE = "chrislusf/seaweedfs:latest";
    private static final int MASTER_CONTAINER_PORT = 9333;
    private static final int VOLUME_CONTAINER_PORT = 8080;
    private static final int MASTER_HOST_PORT = 9333;
    private static final int VOLUME_HOST_PORT = 8088;

    @Inject
    @ConfigProperty(name = "dev.seaweedfs.devservice.enabled", defaultValue = "true")
    boolean enabled;

    private GenericContainer<?> container;

    void onStart(@Observes StartupEvent ev) {
        if (!enabled) {
            LOG.info("[SeaweedFS DevService] desabilitado");
            return;
        }

        LOG.info("[SeaweedFS DevService] iniciando container...");

        @SuppressWarnings("resource")
        GenericContainer<?> c = new GenericContainer<>(IMAGE);
        c.withCommand(
                "server",
                "-dir=/data",
                "-master.port=" + MASTER_CONTAINER_PORT,
                "-volume.port=" + VOLUME_CONTAINER_PORT,
                "-volume.publicUrl=localhost:" + VOLUME_HOST_PORT
        );
        c.withExposedPorts(MASTER_CONTAINER_PORT, VOLUME_CONTAINER_PORT);
        c.withStartupTimeout(Duration.ofSeconds(90));
        c.waitingFor(Wait.forHttp("/cluster/status").forPort(MASTER_CONTAINER_PORT).withStartupTimeout(Duration.ofSeconds(90)));
        c.setPortBindings(List.of(
                MASTER_HOST_PORT + ":" + MASTER_CONTAINER_PORT,
                VOLUME_HOST_PORT + ":" + VOLUME_CONTAINER_PORT
        ));
        container = c;

        try {
            container.start();
            LOG.infof("[SeaweedFS DevService] online - master: localhost:%d | volume publicUrl: localhost:%d",
                    MASTER_HOST_PORT, VOLUME_HOST_PORT);
        } catch (Exception e) {
            LOG.warnf("[SeaweedFS DevService] falhou ao iniciar o container: %s", e.getMessage());
            container = null;
        }
    }

    void onStop(@Observes ShutdownEvent ev) {
        if (container != null && container.isRunning()) {
            LOG.info("[SeaweedFS DevService] parando container...");
            container.stop();
        }
    }
}
