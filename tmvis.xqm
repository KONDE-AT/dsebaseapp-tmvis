xquery version "3.1";
module namespace tmvis="https://digital-archiv/ns/tmvis";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";
import module namespace config="http://www.digital-archiv.at/ns/config" at "../modules/config.xqm";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $tmvis:topic-model := doc($app:indices||'/topic-model.xml')//tei:TEI;


declare function tmvis:list-topics($node as node(), $model as map (*)){
  for $x in $tmvis:topic-model//tei:div[@n]
    let $topic-n := data($x/@n)
    let $words := for $w in $x//tei:item
      return <li>{$w}</li>

    return
      <div class="col">
        <div class="card">
          <div class="card-header">
            <h2>{$topic-n}</h2>
          </div>
          <div class="card-body">
            <ul>{$words}</ul>
          </div>
        </div>
      </div>
};


declare function tmvis:nav($node as node(), $model as map (*)){
  let $menu :=
    <li class="nav-item dropdown">
      <a class="nav-link dropdown-toggle" href="#" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
        Topic Modelling
      </a>
      <div class="dropdown-menu">
        <a class="dropdown-item" href="../tmvis/doc-topic-matrix.html">Doc-Topic-Matrix</a>
        <a class="dropdown-item" href="../tmvis/topics.html">Topics</a>
      </div>
    </li>

  return $menu
};
