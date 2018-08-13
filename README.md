# About

This repository contains accompanying code for the article: **Efficiently paging geospatial data with MongoDB - forwards and backwards!**.

# Setup

You will need `Node.js` and `MongoDB` ( version 3 or greater ) to run the examples.

After cloning the repo, execute:
```
yarn install
```

or if you don't use `yarn`:
```
npm install
```

in the top level directory.

Before running the examples, start MongoDB:

```
mongod --dbpath /some/path
```

This will start an instance which will accept connections at the default url: `mongodb://localhost:27017`. If you wish to modify the connection url used by all examples, edit the [`./src/helpers/with_collection.coffee`](https://github.com/Feeld/efficiently-paging-geospatial-data-code/blob/master/src/helpers/with_collection.coffee) file.

# Running examples

**NOTE:** running any of the examples will create a database named `geo_paging_tutorial` and a collection named `locations` ( the **collection will be cleared** if it exists ). You can change those in the same file as the connection url.


All files in the `src` folder ( apart from `lib.coffee` ) can be ran like so:


```
yarn coffee src/00_create_index.coffee
```

This will use the coffee binary from `./node_modules/.bin/`. You can use `npx` instead of `yarn` to achieve the same result.

The functions exported in the [`src/lib.coffee`](https://github.com/Feeld/efficiently-paging-geospatial-data-code/blob/master/src/lib.coffee) file contain final implementation of the techniques described in the article. [`src/10_page_backwards_final.coffee`](https://github.com/Feeld/efficiently-paging-geospatial-data-code/blob/master/src/10_page_backwards_final.coffee) demonstrates how to use them to page both forwards and backwards.

If you wish to compile the code do JavaScript, you can do something like:

```
yarn coffee -o lib -c src
```
