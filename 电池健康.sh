
if [ "$(id -u)" != "0" ]; then
	
	echo "请使用ROOT权限执行！！" 1>&2
	
	exit 1
	
fi

file="/sys/class/power_supply/battery/uevent"

while true; do

	if [ -f "$file" ]; then
	
		charge_full=$(awk -F= '/POWER_SUPPLY_CHARGE_FULL=/{cf=$2} /POWER_SUPPLY_CHARGE_FULL_DESIGN=/{cfd=$2} END{print cf/cfd*100}' $file)
		
		cycle_count=$(awk -F= '/POWER_SUPPLY_CYCLE_COUNT=/{print $2}' $file)
		
		status=$(awk -F= '/POWER_SUPPLY_STATUS=/{print $2}' $file)
		
		technology=$(awk -F= '/POWER_SUPPLY_TECHNOLOGY=/{print $2}' $file)
		
		capacity=$(awk -F= '/POWER_SUPPLY_CAPACITY=/{print $2}' $file)
		
		current_now=$(awk -F= '/POWER_SUPPLY_CURRENT_NOW=/{print $2}' $file)
		
		current_avg=$(awk -F= '/POWER_SUPPLY_CURRENT_AVG=/{print $2}' $file)
		
		voltage_now=$(awk -F= '/POWER_SUPPLY_VOLTAGE_NOW=/{print $2}' $file)
		
		charge_counter=$(awk -F= '/POWER_SUPPLY_CHARGE_COUNTER=/{print $2}' $file)
		temp=$(awk -F= '/POWER_SUPPLY_TEMP=/{print $2}' $file)
		
		capacity_level=$(awk -F= '/POWER_SUPPLY_HEALTH=/{print $2}' $file)
		
		charge_full_design=$(awk -F= '/POWER_SUPPLY_CHARGE_FULL_DESIGN=/{print $2}' $file)
		
		constant_charge_voltage=$(awk -F= '/POWER_SUPPLY_CONSTANT_CHARGE_VOLTAGE=/{print $2}' $file)
		
		constant_charge_current=$(awk -F= '/POWER_SUPPLY_CONSTANT_CHARGE_CURRENT=/{print $2}' $file)

		clear
		dc=$(cat /sys/class/power_supply/battery/charge_full)
		
		message="电池状态为 ${status}"
		
		message=${message/Charging/正在充电}
		
		message=${message/Discharging/未充电}
		
		echo "$message"
		
		echo "电池健康为 $charge_full%"
		
		echo "电池循环为 $cycle_count 次"
		
		echo "电池类型为 ${technology}"
		
		echo "电池容量为 ${capacity}%"

		result=$(echo "scale = 3; ($current_now / 1000000)" | bc)
		
		if [[ $result == .* ]]; then
		
			echo "电池电流为 0$result A"
			
		else
		
			echo "电池电流为 $result A"
			
		fi

		echo "电池电压为 $(echo "scale = 3; ($voltage_now / 1000000)" | bc) V"
		
		echo "电池温度为 $(echo "scale = 1; ($temp / 10)" | bc) °C"
		
		echo "电池等级为 ${capacity_level}"
		
		echo "电池设计容量为 $(echo "scale = 3; ($charge_full_design / 1000)" | bc) mAh"
		
		echo "电池充满容量为 $(echo "scale = 3; ($dc / 1000)" |bc) mAh"
	else
	
		echo "获取失败！！"
		
	fi

	sleep 0.5
	
done
