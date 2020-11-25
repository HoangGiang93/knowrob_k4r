:- use_module('k4r_db_client.pl').
:- use_module(library('rostest')).

:- begin_tripledb_tests(
        'k4r_db_client',
        'package://knowrob/owl/test/test_owl.owl'
  ).

% Customer

test('k4r_customer_test_1') :-
  k4r_get_link(Link),
  k4r_get_customer_by_id(Link, 10, Customer),
  writeln('Return customer with id 10:'),
  writeln(Customer).

test('k4r_customer_test_2') :-
  k4r_get_link(Link),
  k4r_get_customers(Link, CustomerList),
  k4r_get_customer_by_name(CustomerList, "Megan Firefox", Customer),
  writeln('Return customer with name Megan Firefox:'),
  writeln(Customer).

test('k4r_customer_test_3') :-
  k4r_get_link(Link),
  k4r_post_customer(Link, "TaylorSwift"),
  k4r_get_customers(Link, CustomerList),
  k4r_get_customer_by_name(CustomerList, "TaylorSwift", Customer),
  k4r_get_entity_id(Customer, CustomerId),
  k4r_put_customer(Link, CustomerId, "Taylor Swift"),
  writeln('Return customer with name Taylor Swift:'),
  writeln(Customer).

test('k4r_customer_test_4') :-
  k4r_get_link(Link),
  k4r_get_customers(Link, CustomerList),
  k4r_get_customer_by_name(CustomerList, "Taylor Swift", Customer),
  k4r_get_entity_id(Customer, CustomerId),
  k4r_delete_customer(Link, CustomerId),
  k4r_get_customers(Link, CustomerNewList),
  writeln('Return customer list without customer name Taylor Swift:'),
  writeln(CustomerNewList).

% Store

test('k4r_store_test_1') :-
  k4r_get_link(Link),
  k4r_get_stores(Link, StoreList),
  k4r_get_store_by_name(StoreList, "Refills Lab", Store),
  writeln('Return store with name Refills Lab:'),
  writeln(Store).

test('k4r_store_test_2') :-
  k4r_get_link(Link),
  k4r_post_store(Link, "{
    \"addressAdditional\" : \"Nothing\",
    \"addressCity\" : \"Bremen\",
    \"addressCountry\" : \"DE\",
    \"addressPostcode\" : \"28211\",
    \"addressState\" : \"Land Bremen\",
    \"addressStreet\" : \"Heinrich-Hertz-Strasse\",
    \"addressStreetNumber\" : \"19\",
    \"cadPlanId\" : \"123CAD321\",
    \"latitude\" : 12.3455,
    \"longitude\" : 46.321,
    \"storeName\" : \"Giang Lab\",
    \"storeNumber\" : \"123ABC\"
  }"),
  k4r_get_stores(Link, StoreList),
  k4r_get_store_by_name(StoreList, "Giang Lab", Store),
  writeln('Return store with name Giang Lab:'),
  writeln(Store).

test('k4r_store_test_3') :-
  k4r_get_link(Link),
  k4r_get_link(Link),
  k4r_get_stores(Link, StoreList),
  k4r_get_store_by_name(StoreList, "Giang Lab", Store),
  k4r_get_entity_id(Store, StoreId),
  k4r_put_store(Link, StoreId, "{
    \"addressAdditional\" : \"Changed\",
    \"addressCity\" : \"REFD\",
    \"addressCountry\" : \"DE\",
    \"addressPostcode\" : \"23232\",
    \"addressState\" : \"EDFG\",
    \"addressStreet\" : \"ABCD\",
    \"addressStreetNumber\" : \"19\",
    \"cadPlanId\" : \"123CAD321\",
    \"latitude\" : 12.43,
    \"longitude\" : 32.435,
    \"storeName\" : \"Giang Lab\",
    \"storeNumber\" : \"ABC123\"
  }"),
  k4r_get_stores(Link, StoreList),
  k4r_get_store_by_name(StoreList, "Giang Lab", Store),
  writeln('Return changed store with name Giang Lab:'),
  writeln(Store).

test('k4r_store_test_4') :-
  k4r_get_link(Link),
  k4r_get_stores(Link, StoreList),
  k4r_get_store_by_name(StoreList, "Giang Lab", Store),
  k4r_get_entity_id(Store, StoreId),
  k4r_delete_store(Link, StoreId),
  k4r_get_stores(Link, StoreListNew),
  writeln('Return stores without store name Giang Lab:'),
  writeln(StoreListNew).

% Characteristic

test('k4r_characteristic_test_1') :-
  k4r_get_link(Link),
  k4r_get_characteristics(Link, CharacteristicList),
  writeln('Return characteristics:'),
  writeln(CharacteristicList).

test('k4r_characteristic_test_2') :-
  k4r_get_link(Link),
  k4r_post_characteristic(Link, "New Characteristic"),
  k4r_get_characteristics(Link, CharacteristicList),
  writeln('Return characteristics with New Characteristic'),
  writeln(CharacteristicList).

test('k4r_characteristic_test_3') :-
  k4r_get_link(Link),
  k4r_get_characteristics(Link, CharacteristicList),
  k4r_get_characteristic_by_name(CharacteristicList, "New Characteristic", Characteristic),
  k4r_get_entity_id(Characteristic, CharacteristicId),
  k4r_delete_characteristic(Link, CharacteristicId),
  k4r_get_characteristics(Link, CharacteristicListNew),
  writeln('Return characteristics without New Characteristic'),
  writeln(CharacteristicListNew).

% Property

test('k4r_property_test_1') :-
  k4r_get_link(Link),
  k4r_get_properties(Link, "2", "A1", PropertyList),
  writeln('Return properties of product A1 in store 2:'),
  writeln(PropertyList).

test('k4r_property_test_2') :-
  k4r_get_link(Link),
  k4r_get_characteristics(Link, CharacteristicList),
  k4r_get_characteristic_by_name(CharacteristicList, "Review", Characteristic),
  k4r_get_entity_id(Characteristic, CharacteristicId),
  k4r_post_property(Link, "2", "A1", CharacteristicId, "Good Review"),
  k4r_get_properties(Link, "2", "A1", PropertyList),
  writeln('Return properties of product A1 in store 2 with Good Review:'),
  writeln(PropertyList).

test('k4r_property_test_3') :-
  k4r_get_link(Link),
  k4r_get_characteristics(Link, CharacteristicList),
  k4r_get_characteristic_by_name(CharacteristicList, "Review", Characteristic),
  k4r_get_entity_id(Characteristic, CharacteristicId),
  k4r_delete_property(Link, "2", "A1", CharacteristicId),
  k4r_get_properties(Link, "2", "A1", PropertyList),
  writeln('Return properties of product A1 in store 2 without Good Review:'),
  writeln(PropertyList).

% Product

test('k4r_product_test_1') :-
  k4r_get_link(Link),
  k4r_get_product_by_id(Link, "A1", Product),
  writeln('Return product with id A1:'),
  writeln(Product).

test('k4r_product_test_2') :-
  k4r_get_link(Link),
  k4r_get_products(Link, ProductList),
  k4r_get_product_by_name(ProductList, "Shampoo", Product),
  writeln('Return product with name Shampoo:'),
  writeln(Product).

test('k4r_product_test_3') :-
  k4r_get_link(Link),
  k4r_post_product(Link, "{
    \"depth\" : 3,
    \"description\" : \"a new product\",
    \"gtin\" : \"whatisthis\",
    \"height\" : 2,
    \"length\" : 12,
    \"name\" : \"new product\",
    \"weight\" : 100
  }", "A10"),
  k4r_get_products(Link, ProductList),
  writeln('Return products with product new product at id A10:'),
  writeln(ProductList).

test('k4r_product_test_4') :-
  k4r_get_link(Link),
  k4r_put_product(Link, "{
    \"depth\" : 3,
    \"description\" : \"a new changed product\",
    \"gtin\" : \"whatisthis\",
    \"height\" : 2,
    \"length\" : 12,
    \"name\" : \"new changed product\",
    \"weight\" : 100
  }", "A10"),
  k4r_get_products(Link, ProductList),
  writeln('Return products with product new changed product at id A10:'),
  writeln(ProductList).

test('k4r_product_test_5') :-
  k4r_get_link(Link),
  k4r_post_products(Link, "{
    \"products\": 
      [
        {
          \"depth\" : 5,
          \"description\" : \"a new product 2\",
          \"gtin\" : \"whatisthis\",
          \"height\" : null,
          \"id\" : \"A101\",
          \"length\" : 1,
          \"name\" : \"shampoo\",
          \"weight\" : 2
        }
        ,{
          \"depth\" : 3,
          \"description\" : \"a new product 3\",
          \"gtin\" : \"whatisthis\",
          \"height\" : null,
          \"id\" : \"A102\",
          \"length\" : 1,
          \"name\" : \"paper\",
          \"weight\" : 4
        }
      ]
    }"
  ),
  k4r_get_products(Link, ProductList),
  writeln('Return products with products at id A101 and A102:'),
  writeln(ProductList).

test('k4r_product_test_6') :-
  k4r_get_link(Link),
  k4r_delete_product(Link, "A10"),
  k4r_delete_product(Link, "A101"),
  k4r_delete_product(Link, "A102"),
  k4r_get_products(Link, ProductList),
  writeln('Return products without products at id A10, A101 and A102:'),
  writeln(ProductList).

% Shelf

test('k4r_shelf_test_1') :-
  k4r_get_link(Link),
  k4r_get_shelves(Link, 2, ShelfList),
  writeln('Return Shelves:'),
  writeln(ShelfList).

test('k4r_shelf_test_2') :-
  k4r_get_link(Link),
  k4r_get_shelf_by_id(Link, 1, Shelf),
  writeln('Return Shelf at id 1:'),
  writeln(Shelf).

test('k4r_shelf_test_3') :-
  k4r_get_link(Link),
  k4r_post_shelf(Link, 2, "{
    \"cadPlanId\" : \"an_new_cadPlanId\",
    \"depth\" : 40,
    \"externalReferenceId\" : \"R4\",
    \"height\" : 30,
    \"orientationY\" : 2,
    \"orientationYaw\" : 4,
    \"orientationZ\" : 3,
    \"orientationx\" : 2,
    \"positionX\" : 4,
    \"positionY\" : 5,
    \"positionZ\" : 6,
    \"productGroupId\" : 3,
    \"width\" : 20
 }"),
 k4r_get_shelves(Link, 2, ShelfList),
 writeln('Return Shelves with shelf with externalReferenceId R4:'),
 writeln(ShelfList).

test('k4r_shelf_test_4') :-
  k4r_get_link(Link),
  k4r_get_shelves(Link, 2, ShelfList),
  k4r_get_shelf_by_externalReferenceId(ShelfList, "R4", Shelf),
  k4r_get_shelf_location(Shelf, ShelfPosX, ShelfPosY, ShelfPosZ, ShelfOrientationX, ShelfOrientationY, ShelfOrientationZ, ShelfOrientationW),
  writeln('Position and Orientation:'),
  writeln(ShelfPosX),
  writeln(ShelfPosY),
  writeln(ShelfPosZ),
  writeln(ShelfOrientationX),
  writeln(ShelfOrientationY),
  writeln(ShelfOrientationZ),
  writeln(ShelfOrientationW).

test('k4r_shelf_test_5') :-
  k4r_get_link(Link),
  k4r_get_shelves(Link, 2, ShelfList),
  k4r_get_shelf_by_externalReferenceId(ShelfList, "R4", Shelf),
  k4r_get_entity_id(Shelf, ShelfId),
  k4r_put_shelf(Link, ShelfId, "{
    \"cadPlanId\" : \"an_new_cadPlanId\",
    \"depth\" : 32,
    \"externalReferenceId\" : \"R4\",
    \"height\" : 12,
    \"orientationY\" : 23,
    \"orientationYaw\" : 32,
    \"orientationZ\" : 312,
    \"orientationx\" : 32,
    \"positionX\" : 432,
    \"positionY\" : 421,
    \"positionZ\" : 14,
    \"productGroupId\" : 3,
    \"storeId\" : 2,
    \"width\" : 20
 }"),
 k4r_get_shelves(Link, 2, ShelfList),
 writeln('Return Shelves with shelf with externalReferenceId R4:'),
 writeln(ShelfList).

test('k4r_shelf_test_6') :-
  k4r_get_link(Link),
  k4r_get_shelves(Link, 2, ShelfList),
  k4r_get_shelf_by_externalReferenceId(ShelfList, "R4", Shelf),
  k4r_get_entity_id(Shelf, ShelfId),
  k4r_delete_shelf(Link, ShelfId),
  k4r_get_shelves(Link, 2, ShelfListNew),
  writeln('Return Shelves with shelf without externalReferenceId R4:'),
  writeln(ShelfListNew).

% ShelfLayer

test('k4r_shelf_layer_test_1') :-
  k4r_get_link(Link),
  k4r_get_shelf_layers(Link, 1, ShelfLayerList),
  writeln('Return shelflayers'),
  writeln(ShelfLayerList).

test('k4r_shelf_layer_test_2') :-
  k4r_get_link(Link),
  k4r_get_shelf_layer_by_id(Link, 2, ShelfLayer),
  writeln('Return shelflayer at id 2'),
  writeln(ShelfLayer).

test('k4r_shelf_layer_test_3') :-
  k4r_get_link(Link),
  k4r_post_shelf_layer(Link, 1, "{
    \"level\": 123,
    \"type\": \"type123\",
    \"positionZ\": 34,
    \"width\": 32,
    \"height\": 63,
    \"depth\": 16,
    \"externalReferenceId\": \"E4\"
  }").

test('k4r_shelf_layer_test_4') :-
  k4r_get_link(Link),
  k4r_get_shelf_layers(Link, 1, ShelfLayerList),
  k4r_get_shelf_layer_by_externalReferenceId(ShelfLayerList, "E4", ShelfLayer),
  k4r_get_entity_id(ShelfLayer, ShelfLayerId),
  k4r_delete_shelf_layer(Link, ShelfLayerId),
  writeln('Return ShelfLayers without shelflayer externalReferenceId E4:'),
  k4r_get_shelf_layers(Link, 1, ShelfLayerListNew),
  writeln(ShelfLayerListNew).

% Shopping basket

test('k4r_shopping_basket_test_1') :-
  k4r_get_link(Link),
  k4r_get_shopping_baskets(Link, 2, 1, ShoppingBasketList),
  writeln('Return shopping baskets of store id 2, customer id 1'),
  writeln(ShoppingBasketList).

test('k4r_shopping_basket_test_2') :-
  k4r_get_link(Link),
  k4r_get_shopping_basket_by_id(Link, 2, 1, "A1", ShoppingBasket),
  writeln('Return shopping basket with product id A1'),
  writeln(ShoppingBasket).

test('k4r_shopping_basket_test_3') :-
  k4r_get_link(Link),
  k4r_post_shopping_basket(Link, 2, 1, "{
    \"productId\": \"A3\",
    \"sellingPrice\": 3.99,
    \"quantity\": 6
  }").

test('k4r_shopping_basket_test_4') :-
  k4r_get_link(Link),
  k4r_delete_shopping_basket(Link, 2, 1, "A3"),
  k4r_get_shopping_baskets(Link, 2, 1, ShoppingBasketList),
  writeln('Return shopping baskets without product id A3'),
  writeln(ShoppingBasketList).

:- end_tests(k4r_db_client).
