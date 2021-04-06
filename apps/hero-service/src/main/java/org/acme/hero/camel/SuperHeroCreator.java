package org.acme.hero.camel;

import io.opentracing.SpanContext;
import io.opentracing.Tracer;
import io.opentracing.propagation.Format;
import io.opentracing.propagation.TextMapExtractAdapter;
import org.acme.hero.model.CapeType;
import org.acme.hero.model.Hero;
import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.inject.Named;
import javax.persistence.EntityManager;
import javax.transaction.Transactional;
import java.util.Map;

import static javax.transaction.Transactional.TxType.REQUIRED;

@ApplicationScoped
@Named("superHeroCreator")
public class SuperHeroCreator implements Processor {

    private static final Logger log = LoggerFactory.getLogger(SuperHeroCreator.class);

    @Inject
    private EntityManager entityManager;

    @Inject
    Tracer tracer;

    @Override
    public void process(final Exchange exchange) throws Exception {

        final String legumeItem = exchange.getMessage().getBody(String.class);

        SpanContext spanContext = tracer.extract(Format.Builtin.TEXT_MAP,
                                                 new TextMapExtractAdapter(Map.of(
                                                     "uber-trace-id",
                                                     (String) exchange.getMessage().getHeaders().get("uber-trace-id"))
                                                 ));
        tracer.buildSpan("addHero")
              .asChildOf(spanContext)
              .withTag("legumeItem", legumeItem)
              .startActive(true);

        add(legumeItem);

        tracer.activeSpan().finish();
    }

    @Transactional(REQUIRED)
    Hero add(final String legumeItem) {
        log.info("Legume received: {}", legumeItem);
        final Hero hero = Hero.builder()
                              .name("SUPER-" + legumeItem)
                              .capeType(CapeType.SUPERMAN)
                              .build();

        final Hero createdHero = entityManager.merge(hero);
        log.info("hero created: {}", createdHero);
        return createdHero;
    }
}
