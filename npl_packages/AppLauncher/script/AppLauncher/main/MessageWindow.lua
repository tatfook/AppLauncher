--[[
Title: MessageWindow
Author(s): leio
Date: 2017/12/29
Desc:
use the lib:
------------------------------------------------------------
NPL.load("script/AppLauncher/main/MessageWindow.lua");
local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow");
--Test 1.
MessageWindow.Show("hello message window");
--Test 2.
MessageWindow.Show("hello message window MessageWindow.Buttons.YesNo",function(result)
	commonlib.echo(result);
end,MessageWindow.Buttons.YesNo);
------------------------------------------------------------
]]
NPL.load("(gl)script/ide/System/Windows/Window.lua");
local Window = commonlib.gettable("System.Windows.Window")

local MessageWindow = commonlib.gettable("AppLauncher.MessageWindow");
-- Specifies constants defining which buttons to display on a MessageBox.
MessageWindow.Buttons = {
	--The message box contains Abort, Retry, and Ignore buttons.
	AbortRetryIgnore = 1,
	--  The message box contains an OK button.
	OK = 2,
	-- The message box contains OK and Cancel buttons.
	OKCancel = 3,
	-- The message box contains Retry and Cancel buttons.
	RetryCancel = 4,
	-- The message box contains Yes and No buttons.
	YesNo = 5,
	-- The message box contains Yes, No, and Cancel buttons.
	YesNoCancel = 6,
	-- The message box contains no buttons at all. This is useful when displaying system generated message sequence
	-- Used in Aquarius login procedure
	Nothing = 7,
};

-- Specifies identifiers to indicate the return value of a dialog box.
MessageWindow.DialogResult = {
	-- The dialog box return value is Abort (usually sent from a button labeled Abort).
	Abort = 1,
	-- The dialog box return value is Cancel (usually sent from a button labeled Cancel).
	Cancel = 2,
	-- The dialog box return value is Ignore (usually sent from a button labeled Ignore).
	Ignore = 3,
	-- The dialog box return value is No (usually sent from a button labeled No).
	No = 4,
	-- Nothing is returned from the dialog box. This means that the modal dialog continues running.
	None = 5,
	-- The dialog box return value is OK (usually sent from a button labeled OK).
	OK = 6,
	-- The dialog box return value is Retry (usually sent from a button labeled Retry).
	Retry = 7,
	-- The dialog box return value is Yes (usually sent from a button labeled Yes).
	Yes = 8,
};
MessageWindow.page = nil;
MessageWindow.url = "script/AppLauncher/main/MessageWindow.html";
function MessageWindow.OnInit()
	MessageWindow.page = document:GetPageCtrl();

    MessageWindow.UpdateLanguage()
    MessageWindow.RefreshPage()
end
-- Using a mcml page to show message on a popup window
-- @param <string> info
-- @param <function> callback
-- @param <MessageWindow.Buttons> buttons
function MessageWindow.Show(info,callback,buttons)
	if(not info)then
		MessageWindow.Close();
		return
	end
	MessageWindow.info = info;
	MessageWindow.callback = callback;
	MessageWindow.input_buttons = buttons or MessageWindow.Buttons.OK;

	local window = Window:new();
	window:Show({
		url = MessageWindow.url,
		alignment = "_ct", left = -370/2, top = -250/2, width = 370, height = 250,
		zorder = 10000,
	});
end
function MessageWindow.DoAction(v)
	if(MessageWindow.callback)then
		MessageWindow.callback(v);
	end
	MessageWindow.Close();
end
-- Close this window
function MessageWindow.Close()
	MessageWindow.info = nil;
	MessageWindow.callback = nil;
	MessageWindow.input_buttons = nil;
	if(MessageWindow.page)then
        MessageWindow.page:CloseWindow();
	end
end

function MessageWindow.RefreshPage()
    if MessageWindow.page then
        MessageWindow.page:Refresh(0)
    end
end

function MessageWindow.UpdateLanguage()
    local button_ok = MessageWindow.page:GetNode(tostring(MessageWindow.DialogResult.OK))
    if button_ok then
        button_ok:SetValue(L"确定")
    end

    local button_yes = MessageWindow.page:GetNode(tostring(MessageWindow.DialogResult.Yes))
    if button_yes then
        button_yes:SetValue(L"确定")
    end

    local button_no = MessageWindow.page:GetNode(tostring(MessageWindow.DialogResult.No))
    if button_no then
        button_no:SetValue(L"取消")
    end
end
