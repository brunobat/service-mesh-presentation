package org.acme.hero.resource;

import org.acme.hero.data.HeroItem;
import org.acme.hero.model.Hero;
import org.eclipse.microprofile.faulttolerance.Timeout;

import javax.enterprise.context.ApplicationScoped;
import javax.inject.Inject;
import javax.persistence.EntityManager;
import java.util.List;

import static java.util.stream.Collectors.toList;

@ApplicationScoped
public class HeroResource implements HeroApi {

    @Inject
    EntityManager manager;

    @Timeout(500)
    public List<HeroItem> list() {

        return manager.createQuery("SELECT h FROM Hero h", Hero.class).getResultList().stream()
                      .map(h -> HeroItem.builder()
                                        .name(h.getName())
                                        .id(h.getId())
                                        .capeType(h.getCapeType())
                                        .build())
                      .collect(toList());
    }
}
