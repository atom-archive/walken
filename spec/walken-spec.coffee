path = require 'path'

{walkSync} = require '../lib/walken'

describe "walken", ->
  describe "walkSync(rootPath, callback)", ->
    it "calls back with the path for each child file and directory", ->
      paths = []
      fixturesPath = path.join(__dirname, 'fixtures')
      walkSync fixturesPath, (childPath) ->
        paths.push(childPath)

      paths.sort()
      expect(paths.length).toBe 7
      expect(paths[0]).toBe path.join(fixturesPath, 'c.txt')
      expect(paths[1]).toBe path.join(fixturesPath, 'dir1')
      expect(paths[2]).toBe path.join(fixturesPath, 'dir1', 'a.txt')
      expect(paths[3]).toBe path.join(fixturesPath, 'dir1', 'dir1a')
      expect(paths[4]).toBe path.join(fixturesPath, 'dir1', 'dir1a', 'a1.txt')
      expect(paths[5]).toBe path.join(fixturesPath, 'dir2')
      expect(paths[6]).toBe path.join(fixturesPath, 'dir2', 'b.txt')

    describe "when the callback returns false", ->
      it "does not enter subdirectories", ->
        paths = []
        fixturesPath = path.join(__dirname, 'fixtures')
        walkSync fixturesPath, (childPath) ->
          paths.push(childPath)
          false

        paths.sort()
        expect(paths.length).toBe 3
        expect(paths[0]).toBe path.join(fixturesPath, 'c.txt')
        expect(paths[1]).toBe path.join(fixturesPath, 'dir1')
        expect(paths[2]).toBe path.join(fixturesPath, 'dir2')
