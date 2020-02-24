package main

import (
	"fmt"
	"os"
	"strings"

	"github.com/nlopes/slack"
)

func main() {
	api := slack.New("SLACK-TOKEN")

	slackMessage := "[Atlassian Server] "
	if len(os.Args) > 1 {
		slackMessage += strings.Join(os.Args[1:], " ")
	} else {
		slackMessage += " Empty Message"
	}

	channelID, timestamp, err := api.PostMessage("CHANNEL-ID", slack.MsgOptionText(slackMessage, false))
	if err != nil {
		fmt.Printf("%s\n", err)
		return
	}
	fmt.Printf("MSG SENT channel %s at %s , Message %s ", channelID, timestamp, slackMessage)
}
