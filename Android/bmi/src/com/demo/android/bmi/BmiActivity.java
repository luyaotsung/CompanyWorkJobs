package com.demo.android.bmi;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class BmiActivity extends Activity {
	/** Called when the activity is first created. */
	@Override	
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		// Listen for button clicks
		findView();
		restorePrefs();
		setListensers();
	}
	
	// For Preference 
	private static final String TAG = "BmI";
	public static final String PREF = "BMI_PREF";
	public static final String PREF_HIGHT = "BMI_HEIGHT";
	
	private void restorePrefs (){
		if (Debug.On) {
			Log.d(TAG, "restorePrefs");
		}
		
		SharedPreferences settings = getSharedPreferences(PREF, 0);
		String pref_height = settings.getString(PREF_HIGHT, "");
		if (! "".equals(pref_height)){
			field_height.setText(pref_height);
			field_weight.requestFocus();
		}
	}
			
	@Override
	protected void onPause() {
		super.onPause();
		if (Debug.On) {
			Log.d(TAG,"onPause");
		}
		
		SharedPreferences settings = getSharedPreferences(PREF,0);
		Editor editor = settings.edit();
		editor.putString(PREF_HIGHT, field_height.getText().toString());
		editor.commit();		
	}
	

	// For Menu 
	protected static final int MENU_ABOUT = Menu.FIRST;
	protected static final int MENU_QUIT = Menu.FIRST+1;
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		//menu.add(0, MENU_ABOUT, 0, "Ãö©ó...").setIcon(android.R.drawable.ic_menu_help);
		//menu.add(0, MENU_QUIT, 0, "µ²§ô").setIcon(android.R.drawable.ic_menu_close_clear_cancel);
		if (Debug.On) {
			Log.d(TAG,"onCreateOptionsMenu");
		}
		
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.menu, menu);
		
		return super.onCreateOptionsMenu(menu);
	}

	@Override
	public boolean onOptionsItemSelected(MenuItem item) {
		if (Debug.On){
			Log.d(TAG,"onOptionsItemSelected");
		}
		switch(item.getItemId()){
			//case MENU_ABOUT:
			case R.id.about: 
				openOptionsDialog();
				break;
			//case MENU_QUIT:
			case R.id.finish:
				finish();
				break;
		}
		return super.onOptionsItemSelected(item);
	}

	// For BMI 
	private Button button_alc;
	private EditText field_height;
	private EditText field_weight;
	
	private void findView(){
		if (Debug.On){
			Log.d(TAG,"findView");
		}
		button_alc = (Button) findViewById(R.id.submit);
		field_height = (EditText) findViewById(R.id.Edit_Height);
		field_weight = (EditText) findViewById(R.id.Edit_Weight);
 	}
	
	private void setListensers(){
		button_alc.setOnClickListener(calcBMI);
	}
	
	
	private Button.OnClickListener calcBMI = new Button.OnClickListener() {
		public void onClick(View v) {
			
			Intent intent = new Intent();
			intent.setClass(BmiActivity.this, Report.class);
						
			Bundle bundle = new Bundle();
			bundle.putString("KEY_HEIGHT", field_height.getText().toString());
			bundle.putString("KEY_WEIGHT", field_weight.getText().toString());
			
			intent.putExtras(bundle);
			startActivity(intent);
		}
			
	};
	
	
	private void openOptionsDialog() {
		//Toast.makeText(getApplication(), R.string.app_name ,Toast.LENGTH_SHORT).show();

		if (Debug.On){
			Log.d(TAG,"openOptionsDialog");
		}
		
		new AlertDialog.Builder(BmiActivity.this)
			.setTitle(R.string.about_Title)
			.setMessage(R.string.about_Content)
			.setPositiveButton(R.string.about_OK,
					new DialogInterface.OnClickListener() {
						
						public void onClick(DialogInterface dialog, int which) {
							
						}
					}
			)
			.setNegativeButton(R.string.homepage_Label, 
					new DialogInterface.OnClickListener() {
						
						public void onClick(DialogInterface dialog, int which) {
							Uri uri = Uri.parse(getString(R.string.homepage_Address));
							Intent intent = new Intent(Intent.ACTION_VIEW, uri);
							startActivity(intent);
							
						}
					}
			)
			.show();
	}

	
}