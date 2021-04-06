
package org.acme.legume.camel;

import io.opentracing.Tracer;
import io.opentracing.propagation.Format;
import io.opentracing.propagation.TextMap;
import lombok.extern.slf4j.Slf4j;
import org.acme.legume.data.LegumeItem;
import org.apache.camel.CamelContext;
import org.apache.camel.ProducerTemplate;
import org.eclipse.microprofile.opentracing.Traced;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import static java.nio.charset.StandardCharsets.UTF_8;

@Slf4j
@ApplicationScoped
public class MessageSender {

    @Inject
    private CamelContext context;

    @Inject
    Tracer tracer;

    @Traced
    public String send(final LegumeItem legumeItem) {
        try (final ProducerTemplate template = context.createProducerTemplate()) {
            template.sendBodyAndHeaders("direct:rabbitMQ", legumeItem.getName().getBytes(UTF_8), getTraceContext());
        } catch (IOException e) {
            log.info("Error sending message", e);
        }
        return legumeItem.getName();
    }

    private Map<String, Object> getTraceContext() {
        final Map<String, Object> openTracingContext = new HashMap<>();

        tracer.inject(tracer.activeSpan().context(), Format.Builtin.TEXT_MAP, new TextMap() {
            @Override public Iterator<Map.Entry<String, String>> iterator() {
                throw new UnsupportedOperationException("TextMapInjectAdapter should only be used with Tracer.inject()");
            }

            @Override public void put(final String s, final String s1) {
                openTracingContext.put(s, s1);
            }
        });

        return openTracingContext;
    }

}
