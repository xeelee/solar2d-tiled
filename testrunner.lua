testrunner = {
  run = function(testTable)
    local failed = 0
    for name, test in pairs(testTable) do
      print("Running:", name)
      local status, err = pcall(test)
      if status == true then
        print('OK')
      else
        print('FAIL', err)
        print(debug.traceback())
        failed = failed + 1
      end
    end
    if failed > 0 then
      print(failed, 'FAIL')
    else
      print("All OK")
    end
  end
}
return testrunner
