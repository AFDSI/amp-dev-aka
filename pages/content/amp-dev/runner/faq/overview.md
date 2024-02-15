---
$title@: AMP Overview
$order: 1
teaser:
  image:
    src: '/static/img/faq/faq-overview.jpg'
    width: 570
    height: 320
    alt: FAQ – AMP Overview
  label: Learn more
faq: !g.yaml /shared/data/faq-sub.yaml
---

# AMP Overview

{% with sections = doc.faq.overview %}
{% include 'views/2021/partials/new/accordion.j2' %}
{% endwith %}
