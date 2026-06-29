import 'package:immich_mobile/domain/models/asset/base_asset.model.dart';

extension type const AssetFilter<T extends BaseAsset>(Iterable<T> assets) implements Iterable<T> {
  AssetFilter<T> where(bool Function(T asset) test) => AssetFilter(assets.where(test));
  AssetFilter<T> whereNot(bool Function(T asset) test) => AssetFilter(assets.where((asset) => !test(asset)));

  AssetFilter<T> type(AssetType type) => where((asset) => asset.type == type);
  AssetFilter<T> favorites() => where(_isFavorite);
  AssetFilter<T> notFavorites() => whereNot(_isFavorite);

  AssetFilter<RemoteAsset> remote() => AssetFilter(assets.whereType<RemoteAsset>());
  AssetFilter<RemoteAsset> owned(String ownerId) => remote().where((asset) => asset.ownerId == ownerId);
  AssetFilter<RemoteAsset> visibility(AssetVisibility visibility) => remote().where(_hasVisibility(visibility));
  AssetFilter<RemoteAsset> notVisibility(AssetVisibility visibility) => remote().whereNot(_hasVisibility(visibility));
  AssetFilter<RemoteAsset> archived() => visibility(.archive);
  AssetFilter<RemoteAsset> notArchived() => notVisibility(.archive);
  AssetFilter<RemoteAsset> stacked() => remote().where(_isStacked);
  AssetFilter<RemoteAsset> notStacked() => remote().whereNot(_isStacked);

  AssetFilter<LocalAsset> local() => AssetFilter(assets.whereType<LocalAsset>());
  AssetFilter<LocalAsset> backedUp() => local().where(_isBackedUp);
}

bool _isFavorite(BaseAsset asset) => asset.isFavorite;
bool _isStacked(RemoteAsset asset) => asset.isStacked;
bool _isBackedUp(LocalAsset asset) => asset.remoteAssetId != null;
bool Function(RemoteAsset asset) _hasVisibility(AssetVisibility visibility) =>
    (asset) => asset.visibility == visibility;
