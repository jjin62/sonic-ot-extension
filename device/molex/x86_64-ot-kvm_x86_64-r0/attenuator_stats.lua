-- KEYS - rif IDs
-- ARGV[1] - counters db index
-- ARGV[2] - counters table name
-- ARGV[3] - poll time interval
-- return log

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
    local return_loss = ""
    local out_power = ""
    local act_att = ""

    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OPTICAL_RETURN_LOSS') == 1 then
        return_loss = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OPTICAL_RETURN_LOSS')
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OUTPUT_POWER_TOTAL') == 1 then
        out_power = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_OUTPUT_POWER_TOTAL')
    end
    if redis.call('HEXISTS', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_ACTUAL_ATTENUATION') == 1 then
        act_att = redis.call('HGET', counters_table_name .. ':' .. KEYS[i], 'SAI_OTAI_ATTENUATOR_STAT_ACTUAL_ATTENUATION')
    end

    redis.call('SELECT', state_db)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'opticl-return-loss', return_loss)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'output-power-total', out_power)
    redis.call('HSET', state_table_name .. '|' .. obj_name, 'actual-attenuation', act_att)

end

return logtable
