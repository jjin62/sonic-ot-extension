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
local vid_table_name = "COUNTERS_AMPLIFIER_NAME_MAP"
local state_table_name = "AMPLIFIER_TABLE"



local n = table.getn(KEYS)
for i = 1, n do
    redis.call('SELECT', counters_db)

    local obj_name = redis.call('HGET', vid_table_name, KEYS[i])
    logit(obj_name)
    -- Get new COUNTERS values
    local power_multiple = 100
    local current_multiple = 10
    local in_port = "in_xx"
    local out_port = "out_xx"
    local gain = "0"
    local tilt = "0"
    local total_in = "-60"
    local total_in_c = "-60"
    local total_in_l = "-60"
    local total_out = "-60"
    local total_out_c = "-60"
    local total_out_l = "-60"
    local laser_current = "-60"
    local return_los = "0"

    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_ACTUAL_GAIN') == 1 then
      gain = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_ACTUAL_GAIN')
      gain = strValuePro(gain, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_ACTUAL_GAIN_TILT') == 1 then
      tilt = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_ACTUAL_GAIN_TILT')
      tilt = strValuePro(tilt, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_INPUT_POWER_TOTAL') == 1 then
      total_in = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_INPUT_POWER_TOTAL')
      total_in = strValuePro(total_in, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_INPUT_POWER_C_BAND') == 1 then
      total_in_c = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_INPUT_POWER_C_BAND')
      total_in_c = strValuePro(total_in_c, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_INPUT_POWER_L_BAND') == 1 then
      total_in_l = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_INPUT_POWER_L_BAND')
      total_in_l = strValuePro(total_in_l, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OUTPUT_POWER_TOTAL') == 1 then
      total_out = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OUTPUT_POWER_TOTAL')
      total_out = strValuePro(total_out, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OUTPUT_POWER_C_BAND') == 1 then
      total_out_c = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OUTPUT_POWER_C_BAND')
      total_out_c = strValuePro(total_out_c, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OUTPUT_POWER_L_BAND') == 1 then
      total_out_l = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OUTPUT_POWER_L_BAND')
      total_out_l = strValuePro(total_out_l, power_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_LASER_BIAS_CURRENT') == 1 then
      laser_current = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_LASER_BIAS_CURRENT')
      laser_current = strValuePro(laser_current, current_multiple)
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OPTICAL_RETURN_LOSS') == 1 then
      return_los = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_OA_STAT_OPTICAL_RETURN_LOSS')
      return_los = strValuePro(return_los, power_multiple)
    end

    redis.call('SELECT', state_db)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'ingress-port', in_port)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'egress-port', out_port)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'actual-gain', gain)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'actual-gain-tilt', tilt)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'input-power-total', total_in)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'input-power-c-band', total_in_c)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'input-power-l-band', total_in_l)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-power-total', total_out)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-power-c-band', total_out_c)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-power-l-band', total_out_l)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'laser-bias-current', laser_current)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'optical-return-loss', return_los)

end

return logtable
