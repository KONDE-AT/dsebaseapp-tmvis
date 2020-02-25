xquery version "3.1";
module namespace tmvis="https://digital-archiv/ns/tmvis";

import module namespace app="http://www.digital-archiv.at/ns/templates" at "../modules/app.xql";

declare namespace tei="http://www.tei-c.org/ns/1.0";

declare variable $tmvis:topic-model := doc($app:indices||'/topic-model.xml')//tei:TEI;

declare function tmvis:count-topics(){
  let $topics := count($tmvis:topic-model//tei:div[@n])
  return $topics -1
};

declare function tmvis:list-topics($node as node(), $model as map (*)){
  for $x in $tmvis:topic-model//tei:div[@n]
    let $topic-n := data($x/@n)
    let $topic-id := substring-after($topic-n, ' ')
    let $words := for $w in $x//tei:item
      return <li>{$w}</li>

    return
      <div class="col">
        <div class="card">
          <div class="card-header">
            <h2>
              <a href="topic-document.html?topic={$topic-id}">
                {$topic-n}
              </a>
            </h2>
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
        <a class="dropdown-item" href="../tmvis/topics.html">Topics</a>
        <a class="dropdown-item" href="../tmvis/doc-topic-matrix.html">Doc-Topic-Matrix</a>
      </div>
    </li>

  return $menu
};

declare function tmvis:topic-words($topic-id as xs:string){
  let $words := $tmvis:topic-model//tei:div[@n=$topic-id]//tei:item
  return $words
};

declare function tmvis:header($node as node(), $model as map (*)){
  let $topic := request:get-parameter("topic", "0")
  let $topic-id := "topic "||$topic
  let $first-word := tmvis:topic-words($topic-id)[1]/text()
  let $prev-nr := if (number($topic) = 0) then false() else "topic-document.html?topic="||number($topic) - 1
  let $next-nr :=  if (number($topic) >= tmvis:count-topics()) then false() else "topic-document.html?topic="||number($topic) + 1
  let $prev := if ($prev-nr) then
    <h1><a href="{$prev-nr}"><i class="fas fa-chevron-left" title="prev"/></a></h1>
      else ''
  let $next := if ($next-nr) then
    <h1><a href="{$next-nr}"><i class="fas fa-chevron-right" title="next"/></a></h1>
      else ''
  let $header :=
    <div class="card-header">
      <div class="row">
        <div class="col-md-2">
          {$prev}
        </div>
        <div class="col-md-8">
          <h2>
            {$first-word}
            <br />
            <a>
              <i class="fas fa-info" title="Top Topic Words" data-toggle="modal" data-target="#exampleModal"/>
            </a>
            <a href="#chart">
              <i class="fas fa-chart-bar"/>
            </a>
          </h2>
        </div>
          <div class="col-md-2">
            {$next}
          </div>

      </div>
    </div>
  return
    $header
};

declare function tmvis:topic-top-words($node as node(), $model as map (*)){
  let $topic := request:get-parameter("topic", "0")
  let $topic-id := "topic "||$topic
  for $x in tmvis:topic-words($topic-id)
    return <li>{$x/text()}</li>
};

declare function tmvis:topic-document($node as node(), $model as map (*)){
  let $topic := request:get-parameter("topic", "0")
  let $topic-id := "topic "||$topic
  for $x in $tmvis:topic-model//tei:table[@n=$topic-id]//tei:row
  return
    <tr>
      <td>{$x//tei:cell[3]/text()}</td>
      <td>{$x//tei:cell[1]/text()}</td>
      <td>{$x/tei:cell[2]/text()*1000}</td>
    </tr>
};
