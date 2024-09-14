---
title: Apache Solr - DIH - DataBase Import Handler - MySQL
tags:
  - apache solr
  - java
  - solr
id: '1220'
categories:
  - - Apache Solr
  - - Java
  - - Spring Boot
date: 2016-12-30 08:00:32
author: 'Krzysztof Chruściel'
---

[![SolrLogo](http://codecouple.pl/wp-content/uploads/2016/11/Solr_Logo_on_white-300x152.png)](http://codecouple.pl/wp-content/uploads/2016/11/Solr_Logo_on_white-300x152.png)

W poprzednim [wpisie](http://codecouple.pl/2016/12/09/apache-solr-wyszukiwanie-pelnotekstowe/) opisywałem jak zainstalować silnik wyszukiwania pełnotekstowego **Apache Solr**. Dziś przedstawię wam jak zaimportować dane wykorzystując wbudowany w **Solr'a** mechanizm **DIH** (ang. _Database Import Handler_). Importowane dane będą pochodzić z bazy **MySQL**.
<!-- more -->
Na potrzeby testu utwórzmy bazę o nazwie _products,_ która posiada trzy pola:

*   `id` - unikalne ID naszego produktu w bazie,
*   `product_name` - nazwa naszego produktu,
*   `modified_at` - pole typu **TIMESTAMP,** które przechowuje informację o ostatniej modyfikacji produktu.

**Skrypt SQL** generujący tabelę:

```
CREATE TABLE `products` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `product_name` varchar(64) DEFAULT NULL,
  `modified_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
```

Teraz uzupełnijmy naszą tabelę danymi:

INSERT INTO \`products\`(\`product\_name\`) VALUES ('samsung');
INSERT INTO \`products\`(\`product\_name\`) VALUES ('iphone');
INSERT INTO \`products\`(\`product\_name\`) VALUES ('nokia');

Gdy posiadamy już bazę z danymi musimy pobrać sterownik do pobierania danych z bazy **MySQL**. Sterownik można pobrać tutaj [http://dev.mysql.com/downloads/connector/j/](http://dev.mysql.com/downloads/connector/j/). Po pobraniu, umieszczamy nasz sterownik (plik z rozszerzeniem **\*.jar**) w folderze, gdzie znajduje się nasz serwer **Solr**. Należy umieścić go pod ścieżką `solr-6.3.0\contrib\dataimporthandler\lib.` Jeśli folder `lib` nie istnieje to należy go stworzyć. Numer `6.3.0` jest numerem wersji, na której aktualnie pracuję. Następnie uruchamiamy nasz serwer Solr poprzez wydanie polecenia `solr start` i dodajemy nowy core czyli nasz projekt:

solr start #uruchamiamy aplikacje
solr create -c products #tworzymy core o nazwie products

Od teraz w naszym panelu admina powinien dodać się nowy core (najlepiej na czas kolejnych operacji wyłączyć serwer **Solr**). Ścieżka do naszego nowego core'a to `solr-6.3.0\server\solr\products`. W folderze `conf` edytujemy plik `solrconfig.xml` w którym dodajemy ścieżkę do naszej biblioteki:

<lib dir="${solr.install.dir:../../../..}/contrib/dataimporthandler/lib" regex=".\*\\.jar" />
<lib dir="${solr.install.dir:../../../..}/dist/" regex="solr-dataimporthandler-.\*\\.jar" />

Musimy także aktywować endpoint odpowiedzialny za import i do tego samego pliku `solrconfig.xml` dodajmy wpis:

```
<requestHandler name="/dataimport" class="org.apache.solr.handler.dataimport.DataImportHandler">
    <lst name="defaults">
    <str name="config">data-config.xml</str>
    </lst>
</requestHandler>
```

Następnie w tym samym folderze (conf) tworzymy plik `data-config.xml,` w którym będą zawarte informacje na temat połączenia do bazy oraz jakie dane mają być zaimportowane:

<dataConfig>
<dataSource type="JdbcDataSource"
        driver="com.mysql.jdbc.Driver"
        url="jdbc:mysql://localhost:3306/nazwa\_bazy"
        user="root"
        password="root"/>
<document>
<entity name="products"
        pk="id"
        query="select id, product\_name from products"
        deltaImportQuery="SELECT id, product\_name from products WHERE id='${dih.delta.id}'"
        deltaQuery="SELECT id FROM products `WHERE` `modified_at >` `'${dih.last_index_time}'"`\>
<field column="id" name="id"/>
<field column="product\_name" name="product\_name"/>
</entity>
</document>
</dataConfig>

W sekcji `dataSource` ustawiamy właściwości połączenia do bazy danych. W sekcji `document` modelujemy w **xml** obiekty, które mają zostać pobrane z **MySQL**. Aby pobrać tabelę tworzymy znacznik `entity` z nazwą tabeli. Następnie mamy trzy ważne sekcje:

*   `query` - tutaj definiujemy jakie dane będą pobierane w przypadku pełnego importu (ang. _full-import_),
*   `deltaImportQuery` - tutaj definiujemy jakie dane mają być pobrane w przypadku importu różnic (ang. _delta-import_),
*   `deltaQuery` - zwraca id produktów, które zmieniły się od ostatniego importu.

Następnie musimy zdefiniować jakie pola chcemy persystować w naszej kolekcji. Będzie to kolumna `id` oraz `product_name`. Tworzymy teraz plik `schema.xml,` do którego przekopiowujemy zawartość pliku `managed-schema` i dodajemy wpis o naszym polu:

...
<field name="product\_name" type="text\_general" indexed="true" stored="true"/>
...

Stopujemy aplikację **Solr'a** (`solr stop -all`). Następnie usuwamy plik `managed-schema`, teraz podczas uruchomienia serwera wygeneruje nam się nowy plik z naszą definicją pola `product_name`. Uruchamiamy serwer **Solr.** W panelu administracyjnym wybieramy nasz Core, czyli products i wchodzimy w zakładkę **Dataimport**. Jeśli widzimy treść to znaczy, że dodaliśmy poprawny importer.

[![solrdih](http://codecouple.pl/wp-content/uploads/2016/12/solrDIH.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrDIH.png)

Teraz import możemy wywołać poprzez panel administracyjny lub używając linków:

*   pełny import - **http://localhost:8983/solr/{nazwa\_core}/dataimport?command=full-import**
*   import różnic - **http://localhost:8983/solr/{nazwa\_core}/dataimport?command=delta-import**

Teraz wystarczy udać się do sekcji **Query** i wykonać selekcję. Jeśli wszystko przebiegło pomyślnie powinniśmy otrzymać trzy rekordy, które wstawiliśmy uprzednio do bazy **MySQL**.

[![solrdihselection](http://codecouple.pl/wp-content/uploads/2016/12/solrDIHSelection.png)](http://codecouple.pl/wp-content/uploads/2016/12/solrDIHSelection.png)

Mechanizm importu możemy wykorzystać w naszej aplikacji korzystając z triggerów w **MySQL,** które wywołają skrypt na operację **INSERT** lub **UPDATE,** który wywoła delta-import. Dzięki temu będziemy mieli zawsze aktualne dane w naszym silniku wyszukiwania. Następnie możemy go wykorzystać jako jeden z mikroserwisów w naszej aplikacji. Praktyczne wykorzystanie **Solr'a** wraz ze **Springiem** znajdzie się w kolejnym artykule dotyczącym tego silnika wyszukiwania pełnotekstowego.