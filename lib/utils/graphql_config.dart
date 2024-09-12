import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {
  static final httpLink = HttpLink('${dotenv.env['STRAPI_URL']}/graphql');

  static final client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(),
  );
}