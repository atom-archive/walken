{
  "targets": [
    {
      "target_name": "walken",
      "sources": [ "src/walken.cc" ],
      'conditions': [
        ['OS=="linux"', {
          "defines": [
            "_FILE_OFFSET_BITS=32"
          ]
        }]
      ]
    }
  ]
}
