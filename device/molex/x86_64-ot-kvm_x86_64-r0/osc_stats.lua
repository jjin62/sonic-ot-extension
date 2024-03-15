-- KEYS - rif IDs
-- ARGV[1] - counters db index
-- ARGV[2] - counters table name
-- ARGV[3] - poll time interval
-- return log

local function convertToSigned(unsigned)
  local INT32_MAX = 2^31 - 1
  if unsigned <= INT32_MAX then
    return unsigned
  else
    return unsigned - 2^32
  end
end

local function strValuePro(str, div)
  local v = tonumber(str)
  v = convertToSigned(v)
  return tostring(v / div)
end

local logtable = {}

local function logit(msg)
  logtable[#logtable+1] = tostring(msg)
end

local counters_db = ARGV[1]
local counters_table_name = ARGV[2] 
local state_db = "6"
local vid_table_name = "COUNTERS_OSC_NAME_MAP"
local state_table_name = "OSC_TABLE"



local n = table.getn(KEYS)
for i = 1, n do
  redis.call('SELECT', counters_db)

  local obj_name = redis.call('HGET', vid_table_name, KEYS[i])
  logit(obj_name)
  -- Get new COUNTERS values
  local power_multiple = 100
  local current_multiple = 10
  local power_in = "-60"
  local power_out = "-60"
  local power_drop = "-60"
  local laser_current = "0"
  local freq = "198538052"

  if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OSC_STAT_INPUT_POWER') == 1 then
    power_in = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OSC_STAT_INPUT_POWER')
    power_in = strValuePro(power_in, power_multiple)
  end
  if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OSC_STAT_OUTPUT_POWER') == 1 then
    power_out = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OSC_STAT_OUTPUT_POWER')
    power_out = strValuePro(power_out, power_multiple)
  end
  if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OSC_STAT_LASER_BIAS_CURRENT') == 1 then
    laser_current = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OSC_STAT_LASER_BIAS_CURRENT')
    laser_current = strValuePro(laser_current, current_multiple)
  end

  redis.call('SELECT', state_db)
  redis.call('HSET', state_table_name .. '|' .. obj_name, 'input-power', power_in)
  redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-power', power_out)
  redis.call('HSET', state_table_name .. '|' .. obj_name, 'drop-power', power_drop)
  redis.call('HSET', state_table_name .. '|' .. obj_name, 'laser-bias-current', laser_current)
  redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-frequency', freq)

end

return logtable
