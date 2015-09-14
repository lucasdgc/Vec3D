package ::APP_PACKAGE::;

import android.os.*;
import android.view.*;

public class MainActivity extends org.haxe.lime.GameActivity {
	@Override protected void onCreate (Bundle state) {
		super.onCreate(state);
		
		::if (WIN_FULLSCREEN)::
			hideSystemUi();
		::end::
	}
	
	@Override public void onWindowFocusChanged(boolean hasFocus) {
		super.onWindowFocusChanged(hasFocus);
		
		if(hasFocus) {
			::if (WIN_FULLSCREEN)::
				hideSystemUi();
			::end::
		}
	}
	
	@Override protected void onStart () {
		super.onStart();
		
		::if WIN_FULLSCREEN::
			hideSystemUi();
		::end::
	}
	
	::if (WIN_FULLSCREEN)::
	@Override public boolean onKeyDown(int keyCode, KeyEvent event)
	{
	   if ((systemVisFlags != -1) && (keyCode == KeyEvent.KEYCODE_VOLUME_DOWN || keyCode == KeyEvent.KEYCODE_VOLUME_UP))
	   {
			getWindow().getDecorView().removeCallbacks(hideSystemUiCallback);
			getWindow().getDecorView().postDelayed(hideSystemUiCallback, 3000);
	   }
	   return super.onKeyDown(keyCode, event);
	}
	
	// Callback for restoring IMMERSIVE_STICKY after the system clears it
	int systemVisFlags = -1; // unset
	private final Runnable hideSystemUiCallback = new Runnable() {
		@Override
		public void run() {
			getWindow().getDecorView().setSystemUiVisibility( systemVisFlags );
		}
	};
	
	private void hideSystemUi() {
		getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN
			| WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		
		::if (ANDROID_TARGET_SDK_VERSION >= 16)::	
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
			// KITKAT (4.4) mode: hide the soft nav bar (Immersive mode)
			View decorView = this.getWindow().getDecorView();

			systemVisFlags = View.SYSTEM_UI_FLAG_HIDE_NAVIGATION // [API 14] hide nav bar!
				| View.SYSTEM_UI_FLAG_LAYOUT_STABLE // [API 16] fix screen resolution for app to minimum UI state
				| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN // [API 16] always pretend we're fullscreen, even when not fullscreen
				| View.SYSTEM_UI_FLAG_FULLSCREEN // [API 16] fullscreen mode
				| View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION // [API 16] always pretend the nav bar is missing
			::if (ANDROID_TARGET_SDK_VERSION >= 19)::	
				| View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY // [API 19] hide everything, and fade it if/when it comes back
			::end::
				;
				
			decorView.setSystemUiVisibility( systemVisFlags );
			
			// Create the change listener to listen for flag changes and reset IMMERSIVE_STICKY
			decorView.setOnSystemUiVisibilityChangeListener(new View.OnSystemUiVisibilityChangeListener() {
				@Override
				public void onSystemUiVisibilityChange(int visibility) {
					if ( (visibility & View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY) == 0
						|| (visibility & View.SYSTEM_UI_FLAG_HIDE_NAVIGATION) == 0 ) {
						getWindow().getDecorView().removeCallbacks(hideSystemUiCallback);
						getWindow().getDecorView().postDelayed(hideSystemUiCallback, 3000);
					}
				}
			});
		} else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
			// HONEYCOMB to JELLYBEAN (3.0 - 4.3) mode: hide status bar, allow nav bar
			View decorView = this.getWindow().getDecorView();

			decorView.setSystemUiVisibility(
				View.SYSTEM_UI_FLAG_LAYOUT_STABLE // [API 16] fix screen resolution for app to minimum UI state
				| View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN // [API 16] always pretend we're fullscreen, even when not fullscreen
				| View.SYSTEM_UI_FLAG_FULLSCREEN // [API 16] fullscreen mode
				| View.SYSTEM_UI_FLAG_LOW_PROFILE // [API 14] dim on-screen UI
				);
		} else {
			// GINGERBREAD (2.3) mode: rely on the basic fullscreen stuff from window layout
		}
		::end::
	}
	::end::
}