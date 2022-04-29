class TweetsSchema < GraphQL::Schema
  query Types::QueryType
  mutation Mutations::MutationType
end