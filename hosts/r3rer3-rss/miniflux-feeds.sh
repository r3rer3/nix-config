# Reconciles Miniflux's subscriptions with a JSON list of {title, url}:
# subscribes missing feeds, renames drifted titles and unsubscribes feeds that
# are not in the list. Needs MINIFLUX_URL, ADMIN_USERNAME and ADMIN_PASSWORD.
feeds_json=$1

api() {
  local method=$1 path=$2
  shift 2
  curl --fail-with-body -sS -u "$ADMIN_USERNAME:$ADMIN_PASSWORD" -X "$method" \
    -H 'Content-Type: application/json' "$@" "$MINIFLUX_URL/v1$path"
}

current=$(api GET /feeds)
category=$(api GET /categories | jq '.[0].id')
failed=0

while IFS=$'\t' read -r url title; do
  feed=$(jq -c --arg url "$url" '.[] | select(.feed_url == $url)' <<<"$current")

  if [[ -z $feed ]]; then
    body=$(jq -n --arg url "$url" --argjson category "$category" \
      '{feed_url: $url, category_id: $category}')
    if ! created=$(api POST /feeds -d "$body"); then
      echo "failed to subscribe to $url: $created" >&2
      failed=1
      continue
    fi
    echo "subscribed to $url"
    feed=$(api GET "/feeds/$(jq .feed_id <<<"$created")")
  fi

  # Miniflux stores the post-redirect URL on subscribe, which would make the
  # feed look unwanted on the next run, so the listed URL is pinned back
  if [[ $(jq -r '[.feed_url, .title] | @tsv' <<<"$feed") != "$url"$'\t'"$title" ]]; then
    api PUT "/feeds/$(jq .id <<<"$feed")" \
      -d "$(jq -n --arg url "$url" --arg title "$title" '{feed_url: $url, title: $title}')" >/dev/null
    echo "set $url's title to $title"
  fi
done < <(jq -r '.[] | [.url, .title] | @tsv' "$feeds_json")

while IFS=$'\t' read -r id url; do
  api DELETE "/feeds/$id"
  echo "unsubscribed from $url"
done < <(jq -r --slurpfile wanted "$feeds_json" \
  '.[] | select(.feed_url as $url | $wanted[0] | map(.url) | index($url) | not) | [.id, .feed_url] | @tsv' \
  <<<"$current")

exit "$failed"
