<h1 id="publications"></h1>

<h2 style="margin: 60px 0px 10px;">Publications <temp style="font-size:15px;">[</temp><a href="https://scholar.google.com/citations?user=wIbgZVoAAAAJ" target="_blank" style="font-size:15px;">Google Scholar</a><temp style="font-size:15px;">]</temp><temp style="font-size:15px;">[</temp><a href="https://dblp.org/pid/246/7302.html" target="_blank" style="font-size:15px;">DBLP</a><temp style="font-size:15px;">]</temp></h2>

<p style="margin: 10px 0 20px; color: #555; font-size: 14px; line-height: 1.6;">
I believe great research thrives on collaboration. I aim to lead 1&ndash;2 first-author projects each year while dedicating the rest of my time to collaborating with peers and mentoring students.
<br><span style="font-size: 12px; color: #888;">&#128231; Corr. = corresponding author &nbsp;&middot;&nbsp; &#9878;&#65039; Co-1st = co-first author </span>
</p>

{% assign pubs = site.data.publications.main %}
{% assign grouped = pubs | group_by: "year" | sort: "name" | reverse %}

{% assign total = pubs.size %}

{% for group in grouped %}
<div class="year-block">
  <div class="year-watermark">{{ group.name }}</div>
  <div class="publications">
  <ol class="bibliography" style="counter-reset: none; list-style: none; padding-left: 0;">
  {% for link in group.items %}
  <li>
  <div class="pub-row" style="display: flex; align-items: flex-start;">
    <div style="flex-shrink: 0; margin-right: 15px;">
      <abbr class="badge">{{ total }}.</abbr>
      {% assign total = total | minus: 1 %}
    </div>
    <div style="flex-grow: 1;">
        <div class="title"><a href="{{ link.pdf }}">{{ link.title }}</a></div>
        <div class="author">{{ link.authors }}</div>
        <div class="periodical"><em>{{ link.conference }}</em></div>
      <div class="links">
        {% if link.pdf %}
        <a href="{{ link.pdf }}" class="btn btn-sm z-depth-0" role="button" target="_blank" style="font-size:12px;">PDF{% if link.pages %} ({{ link.pages }} pages){% endif %}</a>
        {% endif %}
        {% if link.code %}
        <a href="{{ link.code }}" class="btn btn-sm z-depth-0" role="button" target="_blank" style="font-size:12px;">Code</a>
        {% endif %}
        {% if link.data %}
        <a href="{{ link.data }}" class="btn btn-sm z-depth-0" role="button" target="_blank" style="font-size:12px;">Dataset</a>
        {% endif %}
        {% if link.track %}
        <a class="btn btn-sm z-depth-0" role="button" style="font-size:12px; cursor: default; pointer-events: none;">{{ link.track }}</a>
        {% endif %}
        {% if link.award %}
        <span style="color: #ff6347; font-size:13px; font-weight:600;">&#127942; {{ link.award }}</span>
        {% endif %}
        {% if link.bibtex %}
        <a href="{{ link.bibtex }}" class="btn btn-sm z-depth-0" role="button" target="_blank" style="font-size:12px;">BibTex</a>
        {% endif %}
        {% if link.notes %}
        <strong> <i style="color:#e74d3c; font-weight:600">{{ link.notes }}</i></strong>
        {% endif %}
        {% if link.others %}
        {{ link.others }}
        {% endif %}
      </div>
    </div>
  </div>
  </li>
  {% endfor %}
  </ol>
  </div>
</div>
{% endfor %}
