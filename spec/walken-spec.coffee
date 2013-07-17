path = require 'path'

{walkSync} = require '../lib/walken'

describe "walken", ->
  describe "walkSync(rootPath, callback)", ->
    it "calls back with the path for each child file and directory", ->
      folders = []
      files = []
      fixturesPath = path.join(__dirname, 'fixtures')
      walkSync fixturesPath, (childPath, isDirectory) ->
        if isDirectory
          folders.push(childPath)
        else
          files.push(childPath)

      files.sort()
      expect(files.length).toBe 4
      expect(files[0]).toBe path.join(fixturesPath, 'c.txt')
      expect(files[1]).toBe path.join(fixturesPath, 'dir1', 'a.txt')
      expect(files[2]).toBe path.join(fixturesPath, 'dir1', 'dir1a', 'a1.txt')
      expect(files[3]).toBe path.join(fixturesPath, 'dir2', 'b.txt')

      folders.sort()
      expect(folders.length).toBe 3
      expect(folders[0]).toBe path.join(fixturesPath, 'dir1')
      expect(folders[1]).toBe path.join(fixturesPath, 'dir1', 'dir1a')
      expect(folders[2]).toBe path.join(fixturesPath, 'dir2')

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
