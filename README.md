# dsebaseapp-tmvis

a [dsebaseapp](https://github.com/KONDE-AT/dsebaseapp) module to visualize the results of a topic model. Be aware, this package DOES NOT do any topic modelling.

## install

add this repo to your dsebaseapp project,

-   either as submodule `git submodule add https://github.com/KONDE-AT/dsebaseapp-tmvis.git tmvis`
-   throug symlink `ln -s ../location/to/tmvis-roep tmvis`
-   or by simply copy and paste the content of this repo into a `tmvis` collection in your dsebaseapp

* add `import module namespace tmvis="https://digital-archiv/ns/tmvis" at "../tmvis/tmvis.xqm";
` to `dsebaseapp/modules/view.xql`

See e.g. [dhd-boas-app](https://github.com/dhd-boas/dhd-boas-app) as reference implementation

## config

In order to make the network-visualization work, you need to perfom topic modeling and store the results of this process in two files:

-   `{dsebaseapp}/data/cache/doc-topic-matrix.json`
-   `{dsebaseapp}/data/indices/topic-model.xml`

### doc-topic-matrix.json

Is a JSON file providing the data to plot a document-topic matrix.

```json
{
  "items": [[0, 1, 123], [0, 2, 343]],
  "docs": ["document 1", "document 2"],
  "topics": ["topic 0", "topic 1"],
  "topic_terms": {
    "topic 0": ["word 1", "word 2"],
    "topic 1": ["word 3", "word 23"]
  }
}
```

The items array is an array of arrays whereas the latter provides

-   the row index
-   the column index
-   the 'weight' of the topic for this document

### topic-model.xml

a basic XML/TEI document containing a

-   `tei:div` for each topic
    -   providing a `tei:list` with `tei:item` for the n most important words of the topic
    -   and a table with
        -   the document ID
        -   documeten title
        -   and the a value representating the topic's importance in this document
