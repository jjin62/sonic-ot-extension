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
local vid_table_name = "COUNTERS_OCM_CHANNEL_NAME_MAP"
local state_table_name = "OCM_CHANNEL_TABLE"


local n = table.getn(KEYS)
for i = 1, n do
  redis.call('SELECT', counters_db)

  local obj_name = redis.call('HGET', vid_table_name, KEYS[i])
  logit(obj_name)
  -- Get new COUNTERS values
  local power_multiple = 100
  local ch_power = "-60"

  if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OCM_CHANNEL_STAT_POWER') == 1 then
    ch_power = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OCM_CHANNEL_STAT_POWER')
    ch_power = strValuePro(ch_power, power_multiple)
  end

  redis.call('SELECT', state_db)
  redis.call('HSET', state_table_name .. '|' .. obj_name, 'power', ch_power)

end

return logtable
