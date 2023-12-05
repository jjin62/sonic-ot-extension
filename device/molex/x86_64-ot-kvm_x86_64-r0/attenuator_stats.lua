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
local vid_table_name = "COUNTERS_ATTENUATOR_NAME_MAP"
local state_table_name = "ATTENUATOR"



local n = table.getn(KEYS)
for i = 1, n do
    redis.call('SELECT', counters_db)

    local obj_name = redis.call('HGET', vid_table_name, KEYS[i])
    logit(obj_name)
    -- Get new COUNTERS values
    local multiple = 100
    local return_los = "0"
    local out_power = "-60"
    local act_att = "0"

    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OPTICAL_RETURN_LOSS') == 1 then
        return_los = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OPTICAL_RETURN_LOSS')
        return_los = strValuePro(return_los, multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OUTPUT_POWER_TOTAL') == 1 then
        out_power = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OUTPUT_POWER_TOTAL')
        out_power = strValuePro(out_power, multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_ACTUAL_ATTENUATION') == 1 then
        act_att = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_ACTUAL_ATTENUATION')
        act_att = strValuePro(act_att, multiple)
    end

    redis.call('SELECT', state_db)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'opticl-return-loss', return_los)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-power-total', out_power)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'actual-attenuation', act_att)

end

return logtable
