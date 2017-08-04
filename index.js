import {NativeModules} from 'react-native'

const RNWifi = NativeModules.RNWifi

export default {
	
	wifiConnect: (text) => {
		RNWifi.wifiConnect(text);

	}
}