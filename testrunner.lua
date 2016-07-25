testrunner = {
  run = function(testTable)
    for name, test in pairs(testTable) do
      print("Running:", name)
      local status, err = pcall(test)
      if status == true then
        print('OK')
      else
        print('FAIL', err)
        print(debug.traceback())
      end
    end
  end
}
return testrunner
