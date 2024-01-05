module.exports = {
  projects: {
    app: {
      schema: ["web/tina/__generated__/schema.gql"],
      documents: [
        "web/tina/__generated__/queries.gql",
        "web/tina/__generated__/frags.gql",
        "web/tina/queries/queries.gql",
        "web/tina/queries/frags.gql",
      ],
    },
  },
};